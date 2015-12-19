PACKAGE_NAME := ceph
DOCKER_NAME := brandt/$(PACKAGE_NAME)-rpm
PACKAGE_URL := http://download.ceph.com/tarballs/ceph-9.2.0.tar.bz2

LOCAL_ARTIFACTS := `pwd`/artifacts
RPMBUILD_SOURCES = rpmbuild/SOURCES
PACKAGE_TAR := ./$(RPMBUILD_SOURCES)/$(notdir $(PACKAGE_URL))

.PHONY: clean build fixperms pkg source

all: fixperms pkg

pkg: artifacts/pkgs source build
	docker run --rm -it -v $(LOCAL_ARTIFACTS):/artifacts $(DOCKER_NAME) bash ./build.sh

build:
	docker build -t $(DOCKER_NAME) .

shell: | build
	@echo "Now run the following:"
	@echo docker run --rm -it -v $(LOCAL_ARTIFACTS):/artifacts $(DOCKER_NAME) bash

source: $(PACKAGE_TAR)

$(PACKAGE_TAR):
	curl -o $(PACKAGE_TAR) $(PACKAGE_URL)

# Container can only have permissions as wide as the layer above
fixperms: rpmbuild artifacts/pkgs
	find $^ -type d -print0 | xargs -0 -n1 chmod ug+rwx
	find $^ -type f -print0 | xargs -0 -n1 chmod ug+rw

artifacts/pkgs: artifacts
	mkdir -p -m 775 $@

clean:
	$(RM) -r ./artifacts/*
