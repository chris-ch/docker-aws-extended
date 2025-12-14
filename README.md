# docker-aws-extended

Lightweight Docker image based on Amazon Linux 2023 with extra development
dependencies commonly needed for building native Python extensions and other
native packages (bzip2, expat, libxml2 dev headers).

## Contents
- Base: Amazon Linux 2023 (from `public.ecr.aws/lambda/provided:al2023`)
- Extra dev packages: `bzip2-devel`, `expat-devel`, `libxml2-devel`

## Getting started

Prerequisites: Docker installed and working locally.

Build the image locally:

```bash
docker build -t docker-aws-extended:latest .
```

Run a container interactively:

```bash
docker run --rm -it docker-aws-extended:latest bash
```

Example: mounting a project directory and building a wheel inside the container
to ensure the system deps are available:

```bash
docker run --rm -it -v "$PWD":/src -w /src docker-aws-extended:latest bash -lc "python3 -m pip wheel . -w dist"
```

## Usage notes
- The image provides a minimal environment for compiling native extensions.
- Add any additional packages in your own `Dockerfile` using this image as a
  base if you need more tooling.

Example Dockerfile using this image as a base:

```dockerfile
FROM ghcr.io/your-username/docker-aws-extended:latest
RUN dnf install -y gcc python3-devel && dnf clean all
```

## Automated Publishing

New versions of the image are automatically built and published to GitHub Container Registry (GHCR) whenever a Git tag following semantic versioning is pushed (e.g., `v1.2.3`).

The workflow (`.github/workflows/docker-publish.yml`) handles:
- Building the image
- Tagging it with the version and `latest`
- Pushing to `ghcr.io/${{ github.repository }}`
- Signing the image with cosign (keyless signing via Sigstore)

### How to publish a new version
1. Update the image as needed (e.g., modify the Dockerfile to add packages).
2. Commit and push changes to the main branch.
3. Create and push a new tag:

   ```bash
   git tag v1.2.3
   git push origin v1.2.3
   ```

The GitHub Actions workflow will automatically trigger, build, and publish the new version.

Published images can be pulled with:

```bash
docker pull ghcr.io/your-username/docker-aws-extended:v1.2.3
# or
docker pull ghcr.io/your-username/docker-aws-extended:latest
```

## Customization
- To add packages, edit the `Dockerfile` in this repo, commit, and create a new tag to trigger publishing.

## License
See the LICENSE file in this repository.

## Questions or contributions
Feel free to open an issue or a pull request if you need additional packages
or improvements.
