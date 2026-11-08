-- Dockerfiles and docker-compose.
return {
  indent = { dockerfile = { tab = false, width = 4 } },

  detect = {
    -- Neovim detects compose files as plain yaml; this lets the compose LSP attach
    filename = {
      ["docker-compose.yml"] = "yaml.docker-compose",
      ["docker-compose.yaml"] = "yaml.docker-compose",
      ["compose.yml"] = "yaml.docker-compose",
      ["compose.yaml"] = "yaml.docker-compose",
    },
  },

  parsers = { "dockerfile" },

  servers = {
    dockerls = true,
    docker_compose_language_service = true,
  },

  linters = { dockerfile = { "hadolint" } },

  tools = { "dockerfile-language-server", "docker-compose-language-service", "hadolint" },
}
