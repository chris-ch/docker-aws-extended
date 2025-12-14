FROM public.ecr.aws/lambda/provided:al2023

RUN dnf install --assumeyes \
    libxml2-devel \
    bzip2-devel \
    expat-devel

CMD [ "bootstrap" ]
