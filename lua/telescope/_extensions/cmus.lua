return require("telescope").register_extension {
  setup = function(ext_config, config)
    require("cmus").setup(ext_config)
  end,
  exports = {},
}
