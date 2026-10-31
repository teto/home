-- call kokoro

vim.keymap.set('n', '<localleader>s', function()
    -- kokoro --text "GMOインターネットグループは、会社のサーバーへ不正アクセスがあったと言っています。外国の通貨を、自動で売ったり買ったりするサービスです." -o file.wav --debug --language j --voice jf_alpha

    vim.fn.jobstart({ 
	  'mpv', '--no-video', vim.fn.expand('~/home/data/audio/notif1.wav') }, { detach = true })

end, { buffer = true, desc = 'Play sound' })



