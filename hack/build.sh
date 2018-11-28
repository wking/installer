#!/bin/sh

set -ex

LAUNCH_PATH="${PWD}"
cd "$(dirname "$0")/.."

PACKAGE_PATH="$(go list -e -f '{{.Dir}}' github.com/openshift/installer)"
if test -z "${PACKAGE_PATH}"
then
	echo "build from your \${GOPATH} (${LAUNCH_PATH} is not in $(go env GOPATH))" 2>&1
	exit 1
fi

LOCAL_PATH="${PWD}"
if test "${PACKAGE_PATH}" != "${LOCAL_PATH}"
then
	echo "build from your \${GOPATH} (${PACKAGE_PATH}, not ${LAUNCH_PATH})" 2>&1
	exit 1
fi

MODE="${MODE:-release}"
LDFLAGS="${LDFLAGS} -X main.version=$(git describe --always --abbrev=40 --dirty)"
TAGS="${TAGS:-}"
OUTPUT="${OUTPUT:-bin/openshift-install}"
export CGO_ENABLED=0

case "${MODE}" in
release)
	TAGS="${TAGS} release"
	if test -n "${RELEASE_IMAGE}"
	then
		LDFLAGS="${LDFLAGS} -X github.com/openshift/installer/pkg/asset/ignition/bootstrap.defaultReleaseImage=${RELEASE_IMAGE}"
	fi
	if test -n "${RHCOS_DEFAULT_CHANNEL}"
	then
		LDFLAGS="${LDFLAGS} -X github.com/openshift/installer/pkg/rhcos.DefaultChannel=${RHCOS_DEFAULT_CHANNEL}"
	fi
	if test -n "${RHCOS_BASE_URL}"
	then
		LDFLAGS="${LDFLAGS} -X github.com/openshift/installer/pkg/rhcos.baseURL=${RHCOS_BASE_URL}"
	fi
	if test -n "${RHCOS_BUILD_NAME}"
	then
		LDFLAGS="${LDFLAGS} -X github.com/openshift/installer/pkg/rhcos.buildName=${RHCOS_BUILD_NAME}"
	fi
	if test "${SKIP_GENERATION}" != y
	then
		go generate ./data
	fi
	;;
dev)
	;;
*)
	echo "unrecognized mode: ${MODE}" >&2
	exit 1
esac

if (echo "${TAGS}" | grep -q 'libvirt_destroy')
then
	export CGO_ENABLED=1
fi

go build -ldflags "${LDFLAGS}" -tags "${TAGS}" -o "${OUTPUT}" ./cmd/openshift-install
