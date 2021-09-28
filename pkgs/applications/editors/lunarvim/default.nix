{ neovim-unwrapped
, wrapNeovim
, fetchFromGitHub
, stdenv
, makeWrapper
, lib
, ripgrep
, git
, fzf
}:

let
  nvim-customized = wrapNeovim neovim-unwrapped {};
in
stdenv.mkDerivation rec {
  pname = "lunarvim";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "LunarVim";
    repo = "LunarVim";
    rev = "238bbf18ac4e35152be06736c75e94a81e3382e8";
    sha256 = "0yfr3vh8p1s9wy21s6bgpp6kp6s9pqlb6k66s76sa22vz4sjiyxb";
  };

  nativeBuildInputs = [ makeWrapper nvim-customized ];
  buildInputs = [ nvim-customized ];

  buildPhase = ''
    echo "hello"
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin

    cp -r $(pwd) $out/lvim

    # trailing slash very important for SPACEVIMDIR
    makeWrapper "${nvim-customized}/bin/nvim" "$out/bin/lvim" \
        --add-flags "-u $out/lvim/init.lua" \
        --set LUNARVIM_RUNTIME_DIR "$out" \
        --set LUNARVIM_CONFIG_DIR "/Users/nielsmentink/.config/lvim" \
        --prefix PATH : ${lib.makeBinPath [ fzf git ripgrep ]}
    runHook postInstall
  '';
}
