FROM registry.access.redhat.com/ubi8/ubi-minimal

ENV NAME=golang \
    GO_MAJOR_VERSION=1 \
    GO_MINOR_VERSION=17 \
    GO_PATCH_VERSION=12 \
    INSTALL_PKGS="go-toolset" \
    CONTAINER_NAME="rhel8/go-toolset"

# Define the VERSION environment variable in a separate step, so we can
# re-use the GO_MAJOR_VERSION, GO_MINOR_VERSION and GO_PATCH_VERSION variables. 
ENV VERSION=$GO_MAJOR_VERSION.$GO_MINOR_VERSION.$GO_PATCH_VERSION \
    SUMMARY="Platform for building and running Go Applications" \
    DESCRIPTION="Go Toolset available as a container is a base platform for \
building and running various Go applications and frameworks. \
Go is an easy to learn, powerful, statically typed language in the C/C++ \
tradition with garbage collection, concurrent programming support, and memory safety features."

LABEL summary="$SUMMARY" \
      description="$DESCRIPTION" \
      io.k8s.description="$DESCRIPTION" \
      io.k8s.display-name="Go $VERSION" \
      name="$CONTAINER_NAME" \
      version="$VERSION"

RUN microdnf install -y --setopt=tsflags=nodocs go-toolset && \
    # rpm -V $INSTALL_PKGS && \
    microdnf clean all -y

# Copy the S2I scripts from the specific language image to $STI_SCRIPTS_PATH.
COPY ./s2i/bin/ $STI_SCRIPTS_PATH

COPY ./root/ /

RUN chown -R 1001:0 $STI_SCRIPTS_PATH && chown -R 1001:0 $APP_ROOT

USER 1001

# Set the default CMD to print the usage of the language image.
CMD $STI_SCRIPTS_PATH/usage