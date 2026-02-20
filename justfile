export NH_FLAKE := justfile_directory()
RUNNER := `sh -c "command -v gamemoderun > /dev/null && echo gamemoderun || echo"`

[private]
default:
    @just -l -u

[private]
format-and-stage:
    @echo -e "\e[35m>\e[0m Formatting code..."
    @nix fmt
    @echo -e "\e[35m>\e[0m Staging commits..."
    @git add .

[linux]
[private]
builder goal *args: format-and-stage
    @{{ RUNNER }} nh os {{ goal }} -- {{ args }}

[macos]
[private]
builder goal *args: format-and-stage
    @nh darwin {{ goal }} -- {{ args }}

[group("rebuild")]
switch *args: (builder "switch" args)

[group("rebuild")]
[linux]
boot *args: (builder "boot" args)

[group("rebuild")]
build *args: (builder "build" args)

[group("rebuild")]
[linux]
test *args: (builder "test" args)

[group("housekeeping")]
update *input:
    @echo -e "\e[35m>\e[0m Updating flake inputs..."
    @nix flake update {{ input }} --refresh
    @echo -e "\e[35m>\e[0m Update nvfetcher sources..."
    @nvfetcher -c ./pkgs/nvfetcher.toml -o ./pkgs/_sources/

[group("housekeeping")]
repl *args: (builder "repl" args)

[group("housekeeping")]
format *args:
    @nix fmt {{ args }}

[group("housekeeping")]
clean:
    @echo -e "\e[35m>\e[0m Cleaning Nix store..."
    @nh clean all -K 1d
    @echo -e "\e[35m>\e[0m Optimising Nix store..."
    @nix store optimise

[group("housekeeping")]
repair:
    @echo -e "\e[35m>\e[0m Verifying Nix store..."
    @nix-store --verify --check-contents --repair
