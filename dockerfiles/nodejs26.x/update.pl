update_archive("ARCHIVE_URL_AMD64", "x86_64");
update_archive("ARCHIVE_URL_ARM64", "arm64");
update_image("base.al2023", "run", "base", "al2023");
update_image("base.al2023", "build", "base", "build-al2023");
update_init();
