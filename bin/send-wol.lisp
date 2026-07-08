#!/usr/bin/env -S sbcl --script

(require :sb-bsd-sockets)

(defconstant +sol-socket+ 1)
(defconstant +so-bindtodevice+ 25)
(defconstant +default-port+ 9)
(defparameter +limited-broadcast+ #(255 255 255 255))

(sb-alien:define-alien-routine ("setsockopt" c-setsockopt) sb-alien:int
  (fd sb-alien:int)
  (level sb-alien:int)
  (optname sb-alien:int)
  (optval (* sb-alien:char))
  (optlen sb-alien:unsigned-int))

(defun usage (&optional (stream *error-output*))
  (format stream "Usage: send-wol.lisp --iface IFACE [--port PORT] MAC~%")
  (format stream "~%")
  (format stream "Example:~%")
  (format stream "  send-wol.lisp --iface enp3s0 aa:bb:cc:dd:ee:ff~%"))

(defun die (format-control &rest args)
  (apply #'format *error-output* format-control args)
  (format *error-output* "~%~%")
  (usage)
  (sb-ext:exit :code 2))

(defun parse-port (string)
  (handler-case
      (let ((port (parse-integer string)))
        (unless (<= 1 port 65535)
          (die "Invalid port: ~A" string))
        port)
    (error ()
      (die "Invalid port: ~A" string))))

(defun hex-digit-p (char)
  (or (digit-char-p char 16) nil))

(defun normalize-mac (string)
  (let ((chars (remove-if (lambda (char)
                            (member char '(#\: #\- #\.)))
                          string)))
    (unless (and (= 12 (length chars))
                 (every #'hex-digit-p chars))
      (die "Invalid MAC address: ~A" string))
    chars))

(defun parse-mac (string)
  (let ((normalized (normalize-mac string)))
    (loop
      with bytes = (make-array 6 :element-type '(unsigned-byte 8))
      for i below 6
      for start = (* i 2)
      do (setf (aref bytes i)
               (parse-integer normalized :start start :end (+ start 2) :radix 16))
      finally (return bytes))))

(defun make-magic-packet (mac)
  (let ((packet (make-array 102 :element-type '(unsigned-byte 8))))
    (loop for i below 6
          do (setf (aref packet i) #xff))
    (loop for repeat below 16
          for offset = (+ 6 (* repeat 6))
          do (replace packet mac :start1 offset))
    packet))

(defun bind-socket-to-device (socket interface)
  (let* ((fd (sb-bsd-sockets:socket-file-descriptor socket))
         (length (length interface)))
    (when (zerop length)
      (die "Interface name cannot be empty"))
    (sb-alien:with-alien ((buffer (array sb-alien:char 256)))
      (when (>= length 256)
        (die "Interface name is too long: ~A" interface))
      (loop for i below length
            do (setf (sb-alien:deref buffer i) (char-code (char interface i))))
      (setf (sb-alien:deref buffer length) 0)
      (let ((rc (c-setsockopt fd
                              +sol-socket+
                              +so-bindtodevice+
                              (sb-alien:addr (sb-alien:deref buffer 0))
                              (1+ length))))
        (unless (zerop rc)
          (die "Failed to bind socket to interface ~A. Try running as root or with CAP_NET_RAW."
               interface))))))

(defun send-wol (interface mac &key (port +default-port+))
  (let ((socket (make-instance 'sb-bsd-sockets:inet-socket
                               :type :datagram
                               :protocol :udp))
        (packet (make-magic-packet mac)))
    (unwind-protect
         (progn
           (setf (sb-bsd-sockets:sockopt-broadcast socket) t)
           (bind-socket-to-device socket interface)
           (sb-bsd-sockets:socket-connect socket +limited-broadcast+ port)
           (sb-bsd-sockets:socket-send socket packet nil))
      (sb-bsd-sockets:socket-close socket))))

(defun parse-args (args)
  (loop
    with interface = nil
    with port = +default-port+
    with mac = nil
    while args
    for arg = (pop args)
    do (cond
         ((string= arg "--help")
          (usage *standard-output*)
          (sb-ext:exit :code 0))
         ((string= arg "--iface")
          (unless args
            (die "Missing value after --iface"))
          (setf interface (pop args)))
         ((string= arg "--port")
          (unless args
            (die "Missing value after --port"))
          (setf port (parse-port (pop args))))
         ((char= #\- (char arg 0))
          (die "Unknown option: ~A" arg))
         (mac
          (die "Unexpected extra argument: ~A" arg))
         (t
          (setf mac (parse-mac arg))))
    finally
       (unless interface
         (die "Missing required --iface IFACE"))
       (unless mac
         (die "Missing required MAC address"))
       (return (values interface port mac))))

(multiple-value-bind (interface port mac)
    (parse-args (cdr sb-ext:*posix-argv*))
  (send-wol interface mac :port port))
