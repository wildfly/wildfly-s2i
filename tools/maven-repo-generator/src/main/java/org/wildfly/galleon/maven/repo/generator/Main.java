package org.wildfly.galleon.maven.repo.generator;

import static io.undertow.Handlers.resource;
import io.undertow.Undertow;
import io.undertow.server.handlers.resource.PathResourceManager;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.file.FileVisitResult;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.SimpleFileVisitor;
import java.nio.file.attribute.BasicFileAttributes;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

/**
 *
 * @author jdenise
 */
public class Main {
    
    public static void main(String[] args) throws Exception {
        if (args.length != 1) {
            throw new Exception("Offliner file path is missing");
        }
        Path offlinerFile = Paths.get(args[0]);
        if (!Files.exists(offlinerFile)) {
            throw new Exception("Offliner file doesn't exist");
        }
        Path zipFile = Paths.get("maven-repo.zip");
        if (Files.exists(zipFile)) {
            Files.delete(zipFile);
        }
        String localRepo = System.getProperty("maven.local.repo",
                Paths.get(System.getProperty("user.home")).resolve(".m2/repository").toString());
        Undertow server = Undertow.builder()
                .addHttpListener(7777, "127.0.0.1")
                .setHandler(resource(new PathResourceManager(Paths.get(localRepo), 100))
                        .setDirectoryListingEnabled(true))
                .build();
        server.start();
        Path tmpPath = Files.createTempDirectory("wf-zipped-repo");
        try {
            Path repoPath = tmpPath.resolve("repository");
            String[] offlinerArgs = {"--url", "http://127.0.0.1:7777", offlinerFile.toString(), "--dir", repoPath.toString()};
            com.redhat.red.offliner.Main.main(offlinerArgs);
            System.out.println("\nZipping repo...");
            zipRepo(tmpPath, zipFile);
        } finally {
            deleteDir(tmpPath);
            server.stop();
        }
        System.out.println("Maven repo zipped in " + zipFile);
    }
    
    private static void deleteDir(Path path) throws IOException {
        Files.walkFileTree(path, new SimpleFileVisitor<Path>() {
            @Override
            public FileVisitResult visitFile(Path file, BasicFileAttributes attrs) throws IOException {
                Files.delete(file);
                return FileVisitResult.CONTINUE;
            }
            
            @Override
            public FileVisitResult postVisitDirectory(Path dir, IOException exc) throws IOException {
                Files.delete(dir);
                return FileVisitResult.CONTINUE;
            }
        });
    }
    
    private static void zipRepo(Path repo, Path zipFile) throws Exception {
        try ( FileOutputStream fileWriter = new FileOutputStream(zipFile.toFile());  ZipOutputStream zip = new ZipOutputStream(fileWriter)) {
            zipDir(repo, repo, zip);
        }
    }

    private static void zipDir(Path rootPath, Path dir, ZipOutputStream zip) throws Exception {
        for (File file : dir.toFile().listFiles()) {
            zipFile(rootPath, file.toPath(), zip);
        }
    }

    private static void zipFile(Path rootPath, Path srcFile, ZipOutputStream zip) throws Exception {
        if (Files.isDirectory(srcFile)) {
            zipDir(rootPath, srcFile, zip);
        } else {
            byte[] buf = new byte[1024];
            int len;
            try ( FileInputStream in = new FileInputStream(srcFile.toFile())) {
                Path filePath = rootPath.relativize(srcFile);
                zip.putNextEntry(new ZipEntry(filePath.toString()));
                while ((len = in.read(buf)) > 0) {
                    zip.write(buf, 0, len);
                }
            }
        }
    }
}
