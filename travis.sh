#!/bin/sh -x
# Continuous integration script for Travis

# Build the library and install it.
echo "## Building and installing libs2..."
cd geometry
cmake .
make -j3
sudo make install

if [ "${TRAVIS_OS_NAME}" = "linux" ]; then
	sudo ldconfig -v | grep libs2
fi

# Build and run the C++ tests
echo "## Building and running the C++ tests..."
cd tests
cmake .
make -j3
./tests || exit 1


# Build and install the Python bindings
echo "## Building and installing the Python bindings..."
cd ../python
cmake .
make VERBOSE=1
sudo make install

# Run the Python tests
echo "## Running the Python tests..."
python -v -c 'import s2'
python test.py || exit 1

