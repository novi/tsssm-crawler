BUILDOPTS=-Xlinker -L/usr/lib

SWIFTC=swiftc
SWIFT=swift
ifdef SWIFTPATH
    SWIFTC=$(SWIFTPATH)/bin/swiftc
    SWIFT=$(SWIFTPATH)/bin/swift
endif
OS := $(shell uname)
ifeq ($(OS),Darwin)
	BUILDOPTS=-Xlinker -L/usr/local/lib -Xcc -I/usr/local/include/mysql -Xcc -I/usr/local/include
endif

all: debug

release: CONF_ENV=release
release: build_;

debug: CONF_ENV=debug
debug: build_;

build_:
	$(SWIFT) build -v --configuration $(CONF_ENV) $(BUILDOPTS) -Xswiftc -DSWIFT3_DEV

test: build
	$(SWIFT) test
	
clean:
	$(SWIFT) build --clean build

distclean:
	$(SWIFT) build --clean dist
