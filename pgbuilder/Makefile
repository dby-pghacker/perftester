all: clean checkout configure build copy createrepo

clean:
	rm -rf ~/rpmbuild

checkout:
	./checkout.sh

configure:
	./configure.sh

build:
	rpmbuild -ba "./postgresql.spec"

copy:
	mkdir -p rpms
	find ~/rpmbuild -name '*.rpm' -exec cp {} rpms/ \;

createrepo:
	createrepo rpms/
