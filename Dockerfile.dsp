ARG DART_VERSION="atsigncompany/buildimage:riscv"
FROM ${DART_VERSION} AS build
WORKDIR /app
COPY ./bin/showplatform.dart .
RUN dart compile exe /app/showplatform.dart -o /app/dartshowplatform

FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /app/dartshowplatform /app/dartshowplatform
ENTRYPOINT ["/app/dartshowplatform"]