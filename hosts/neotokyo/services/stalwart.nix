{
  config,
  secrets,
  withSecrets,
  ...
}:
let
  forwardingAddress = secrets.accounts.mail.fastmail_perso.email;
  certificateName = "blog.${config.networking.fqdn}";
in
{
  enable = withSecrets && true;
  # shouldn't it inherit it ?
  stateVersion = "26.05";
  openFirewall = true;

  # systemd reads the ACME files as root and exposes them only to Stalwart.
  credentials = {
    tls_cert = "${config.security.acme.certs.${certificateName}.directory}/fullchain.pem";
    tls_key = "${config.security.acme.certs.${certificateName}.directory}/key.pem";
  };

  settings = {
    server.hostname = config.networking.fqdn;
    certificate.public = {
      cert = "%{file:/run/credentials/stalwart.service/tls_cert}%";
      private-key = "%{file:/run/credentials/stalwart.service/tls_key}%";
      # SMTP clients commonly omit SNI.
      default = true;
    };
    server.listener.smtp = {
      bind = [ "[::]:25" ];
      protocol = "smtp";
      max-connections = 32;
    };

    session.auth = {
      require = false;
      mechanisms = false;
    };

    session.data.limits = {
      messages = 5;
      size = 25 * 1024 * 1024;
    };

    session.rcpt = {
      # Rewrite every envelope recipient before directory and relay checks.
      rewrite = "'${forwardingAddress}'";
      directory = false;
      # Only the fixed destination can be relayed, even if rewriting changes.
      relay = "rcpt == '${forwardingAddress}'";
    };

    # Deliver to Fastmail's published MX servers, with normal MX failover.
    queue.strategy.route = "'mx'";

    # This forwarding-only server has no DKIM identity for its own reports.
    # Do not generate aggregate mail referencing nonexistent default signers.
    report.tls.aggregate.send = false;
    report.dmarc.aggregate.send = false;

    queue.limiter.inbound = [
      {
        # Connection attempts per source IP.
        enable = true;
        key = [ "remote_ip" ];
        rate = "30/1m";
      }
      {
        # Bound aggregate connection attempts across all source IPs.
        enable = true;
        key = [ "listener" ];
        rate = "120/1m";
      }
      {
        # Checked at RCPT after rewriting; applies to each message transaction.
        enable = true;
        key = [
          "remote_ip"
          "rcpt"
        ];
        rate = "60/1h";
      }
      {
        # The rewritten recipient gives a shared limit across all source IPs.
        enable = true;
        key = [ "rcpt" ];
        rate = "300/1h";
      }
    ];

    # No grouping key: share the queue quota across all incoming mail.
    # SMTP returns a temporary failure when full so senders can retry later.
    queue.quota.forwarding = {
      enable = true;
      match = "true";
      messages = 1000;
      size = 1024 * 1024 * 1024;
    };
  };
}
