using BinaryBuilder

name = "nlminb"
version = v"0.1.1"

# Collection of sources required to build NLopt
sources = [
    GitSource("https://github.com/jl-spatial/exactextract.git",
    "47dd337f171a535e75cb494e23de41b8bf3c3c5d"), # v0.1.1
]

# Bash recipe for building across all platforms
script = raw"""

## compile by hand
# if [[ "${proc_family}" == "intel" ]]; then
#    FLAGS="-mfpmath=sse -msse2 -mstackrealign"
# fi

cd $WORKSPACE/srcdir/exactextract
mkdir cmake-build-release
cd cmake-build-release
cmake -DBUILD_DOC:=OFF -DCMAKE_BUILD_TYPE=Release ..
make

# CFLAGS="-fPIC -DNDEBUG  -Iinclude -O2 -Wall -std=gnu99 ${FLAGS}" \
#    FFLAGS="-fPIC -fno-optimize-sibling-calls -O2 ${FLAGS}" \
#    target=${libdir}/libnlminb.${dlext} make
"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = expand_gfortran_versions(supported_platforms())

# The products that we will ensure are always built
products = [
    LibraryProduct("libnlminb", :libnlminb),
]

# Dependencies that must be installed before this package can be built
dependencies = [
  Dependency("CompilerSupportLibraries_jll"),
  Dependency("GDAL_jll"),
  Dependency("GEOS_jll"),
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)
