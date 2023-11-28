update_archive("ARCHIVE_URL_AMD64", "x86_64");
update_archive("ARCHIVE_URL_ARM64", "arm64");
update_image("base.al2", "run", "base", "al2");
update_image("base.al2", "build", "base", "build-al2");
update_init();
