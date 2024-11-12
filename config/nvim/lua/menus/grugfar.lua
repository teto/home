return {

  {
    name = "Replace",
    cmd = 'GrugFar',
  },
  {
    name = "Replace current word",
    cmd = function ()
	  require('grug-far').open({ prefills = { search = vim.fn.expand("<cword>") } })
    end
  },


}

