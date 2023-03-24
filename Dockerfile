FROM dart:stable AS buildimage
ENV HOMEDIR=/atsign
ENV BINARYDIR=${HOMEDIR}/at_activate
ENV USER_ID=1024
ENV GROUP_ID=1024
WORKDIR ${HOMEDIR}
# Context for this Dockerfile needs to be {at_libraries_repo}/packages/at_onboarding_cli
# If building manually then (from packages/at_onboarding_cli):
## docker build -t atsigncompany/at_activate .
COPY . .
RUN \
  mkdir -p "$HOMEDIR" ; \
  mkdir -p "$BINARYDIR" ; \
  case "$(dpkg --print-architecture)" in \
        amd64) \
            ARCH="x64";; \
        armhf) \
            ARCH="arm";; \
        arm64) \
            ARCH="arm64";; \
    esac; \
  dart pub get ; \
  dart pub upgrade ; \
  dart compile exe bin/showplatform.dart -o "$BINARYDIR"/showplatform ; \
  tar cvzf /atsign/showplatform-linux-"$ARCH".tgz "$BINARYDIR"/showplatform

  
# Second stage of build FROM scratch
FROM scratch AS export-stage
COPY --from=buildimage /atsign/showplatform-linux-*.tgz .