# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

# Collection of sources required to build LCIOBuilder
sources = [
    "https://github.com/iLCSoft/LCIO/archive/v02-12-01.tar.gz" =>
    "8a3d2e66c2f2d4489fc2e1c96335472728d913d4090327208a1d93b3b0728737",

]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
tar xzf Zlib.v1.2.11.x86_64-linux-gnu.tar.gz
cmake -DCMAKE_INSTALL_PREFIX=$prefix -DCMAKE_TOOLCHAIN_FILE=/opt/$target/$target.toolchain LCIO-02-12-01/
make 
make install

"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    Linux(:x86_64, :glibc),
    Linux(:x86_64, :musl)
]

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "liblcio", :liblcio),
    LibraryProduct(prefix, "libsio", :libsio)
]

# Dependencies that must be installed before this package can be built
dependencies = [
    "https://github.com/bicycle1885/ZlibBuilder/releases/download/v1.0.1/build_Zlib.v1.2.11.jl"
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, "LCIOBuilder", sources, script, platforms, products, dependencies)

