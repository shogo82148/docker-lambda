update_archive("ARCHIVE_URL_AMD64", "x86_64");
update_image("base", "run", "base", "alami");
dump_packages("x86_64", "public.ecr.aws/amazonlinux/amazonlinux:1", "rpm -qa --dbpath /rpm");
