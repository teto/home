# Clanki Nix Package

This directory contains a Nix package for [clanki](https://github.com/alvenw/clanki), a terminal-based Anki review client.

## Usage

### Basic Installation

To install clanki:

```bash
nix-env -f . -iA clanki
```

### Development Environment

For a complete development environment with all dependencies:

```bash
nix-shell shell.nix
```

This will provide:
- The clanki package
- Anki desktop application
- Python 3
- Required Python dependencies (textual, textual-image)
- A wrapper script `clanki-wrapper` that sets up the environment correctly

### Running Clanki

Due to the complex dependency on the Anki Python library, you have a few options:

#### Option 1: Use the wrapper script (recommended)

```bash
clanki-wrapper
```

The wrapper will automatically try to set up PYTHONPATH to include Anki's Python library.

#### Option 2: Manual PYTHONPATH setup

```bash
# Find where anki is installed
ANKI_LIB=$(find $(nix-build -A anki --no-out-link) -name "anki" -type d | head -1)
export PYTHONPATH="$ANKI_LIB:$PYTHONPATH"

# Run clanki
clanki
```

#### Option 3: Use with existing Anki installation

If you already have Anki installed system-wide:

```bash
export PYTHONPATH="/path/to/anki/python/library:$PYTHONPATH"
clanki
```

## Package Details

- **Source**: https://github.com/alvenw/clanki
- **Version**: 0.1.0 (git revision 15c9847a05a4a6db25d4abc1e99a7da3dacb073b)
- **License**: AGPL-3.0-or-later (GNU Affero General Public License v3.0 or later)
- **Dependencies**:
  - Python 3.10+
  - textual >= 0.50
  - textual-image[textual] >= 0.7
  - anki == 25.9.2 (provided by nixpkgs.anki)

## Important Notes

**Clanki requires the Anki Python library to be available at runtime.** The Nix package builds successfully, but the resulting binary will not work without the Anki Python library being available in `PYTHONPATH`.

### Why This Is Necessary

The Anki desktop application bundles its own Python library, which is not available as a separate Python package in nixpkgs. Clanki imports from this library (e.g., `from anki.collection import Collection`), so the library must be available at runtime.

### Version Compatibility

- The nixpkgs.anki package provides version 25.09.2
- Clanki requires anki == 25.9.2
- These versions are compatible for basic functionality

## Troubleshooting

### "ModuleNotFoundError: No module named 'anki'"

This error occurs when the Anki Python library is not in your `PYTHONPATH`. Solutions:

1. **Use the wrapper script** (recommended):
   ```bash
   clanki-wrapper
   ```

2. **Set PYTHONPATH manually**:
   ```bash
   ANKI_PATH="$(nix-build '<nixpkgs>' -A anki --no-out-link)"
   export PYTHONPATH="$ANKI_PATH/lib/python*/site-packages:$PYTHONPATH"
   clanki
   ```

3. **Check Anki installation**:
   ```bash
   nix profile install nixpkgs#anki
   ```

### Collection Lock Errors

Clanki cannot access your Anki collection if:
- Anki desktop is currently running
- Another instance of Clanki is running
- The collection file is corrupted

Solution: Close Anki desktop and any other processes that might be using the collection.

## Building

To build the package manually:

```bash
nix-build -A clanki
```

## Development

To enter a development shell with all dependencies:

```bash
nix-shell
```

This will provide a Python environment with all the necessary dependencies for development and testing.
