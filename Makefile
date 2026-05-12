BINARY = bubble-sort
SRC = src
BUILD = build
PKG = $(BUILD)/bubble-sort-pkg
BIN_DIR = $(PKG)/usr/local/bin
DEBIAN_DIR = $(PKG)/DEBIAN
CONTROL_FILE = DEBIAN/control

CXX = g++
CXXFLAGS = -Wall -Wextra -std=c++11

all: check deb

check:
	@which $(CXX) > /dev/null || (echo "g++ not found. Install build-essential." && exit 1)
	@which dpkg-deb > /dev/null || (echo "dpkg-deb not found. Install dpkg-dev." && exit 1)

$(BINARY): $(SRC)/main.cpp
	$(CXX) $(CXXFLAGS) $< -o $@

deb: $(BINARY)
	rm -rf $(BUILD)
	mkdir -p $(BIN_DIR)
	mkdir -p $(DEBIAN_DIR)
	cp $(BINARY) $(BIN_DIR)/
	cp $(CONTROL_FILE) $(DEBIAN_DIR)/
	dpkg-deb --build $(PKG)
	@echo "Package created: $(PKG).deb"

run: $(BINARY)
	./$(BINARY)

clean:
	rm -f $(BINARY)
	rm -rf $(BUILD)
	