# NixCTl
NixCTL is a command-line tool designed to be a wrapper around various Nix commands, aiming to streamline Nix system configuration tasks. 

NixCTL is written purely in rust!

NOTE: Run NixCTL as normal user(not as root)
[![asciicast](https://asciinema.org/a/mDbFNMZdgdKwI4oEglPRNsjqE.svg)](https://asciinema.org/a/mDbFNMZdgdKwI4oEglPRNsjqE)

Uses [nix-output-monitor](https://github.com/maralorn/nix-output-monitor) and [nvd](https://gitlab.com/khumba/nvd)

![example-screenshot](https://github.com/Celibistrial/nixctl/assets/82810795/1c0328c9-e077-43cb-a5aa-b62d5cf93881)


# Installation

- Add this flake to inputs in your configuration:

```nix
# flake.nix
{
  inputs = {
    # ...
    nixctl = {
      url = "github:Celibistrial/nixctl";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # ...
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: {
    # ...
   };
  };
}

```

- Mention it in the packages
```nix
  environment.systemPackages = with pkgs; [
    inputs.nixctl.packages.x86_64-linux.default
    nvd
    nix-output-monitor
  ];
```




# TODOS
[See here](./todo.org)
