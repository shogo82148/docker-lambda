update_archive("ARCHIVE_URL_AMD64", "x86_64");
update_archive("ARCHIVE_URL_ARM64", "arm64");
dump_packages("x86_64", "public.ecr.aws/amazonlinux/amazonlinux:2", "rpm -qa --dbpath /rpm");
dump_packages("arm64", "public.ecr.aws/amazonlinux/amazonlinux:2", "rpm -qa --dbpath /rpm");
