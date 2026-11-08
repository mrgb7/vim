-- Terraform / HCL.
return {
  detect = {
    -- Neovim's content sniffing can pick `tf` (TinyFugue) for new/empty files
    extension = { tf = "terraform" },
  },

  parsers = { "hcl", "terraform" },

  servers = { terraformls = true },

  formatters = {
    terraform = { "terraform_fmt" },
    ["terraform-vars"] = { "terraform_fmt" },
    hcl = { "terraform_fmt" },
  },

  linters = { terraform = { "tflint" } },

  tools = { "terraform-ls", "tflint" },
}
