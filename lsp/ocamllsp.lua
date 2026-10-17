return {
  cmd = { "ocamllsp" },
  filetypes = { "ocaml", "ocaml.menhir", "ocaml.interface", "ocaml.ocamllex", "reason", "dune" },
  root_markers = { "*.opam", "esy.json", "package.json", ".git", "dune-project", "dune-workspace" },
  settings = {
    codelens = { enable = true },
    extendedHover = { enable = true },
  },
}
