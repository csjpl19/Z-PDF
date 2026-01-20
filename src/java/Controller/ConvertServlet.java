package Controller;

import com.convertapi.client.Config;
import com.convertapi.client.ConversionResult;
import com.convertapi.client.ConvertApi;
import com.convertapi.client.Param;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.UUID;
import java.util.concurrent.ExecutionException;
import java.nio.file.Path;
import java.util.List;
import java.util.ArrayList;
import java.util.concurrent.CompletableFuture;

@WebServlet(name = "ConvertServlet", urlPatterns = {"/convert"})
@MultipartConfig
public class ConvertServlet extends HttpServlet {

    private static final String API_KEY = "rmEwg3a6p0KijsvfjkcIxZQjy2JT1eli";
    private static final String UPLOAD_DIR = "uploads";
    private static final String CONVERTED_DIR = "converted_files";

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Config.setDefaultApiCredentials(API_KEY);

        String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdir();
        }

        Part filePart = request.getPart("file");
        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        String uniqueFileName = UUID.randomUUID().toString() + "_" + fileName;
        File uploadedFile = new File(uploadPath, uniqueFileName);

        String fromFormat = request.getParameter("fromFormat");
        String toFormat = request.getParameter("toFormat");

        try (InputStream input = filePart.getInputStream()) {
            Files.copy(input, uploadedFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
        }

        try {
            ConversionResult result = ConvertApi.convert(fromFormat, toFormat, new Param("file", uploadedFile.toPath()))
                    .get();

            String convertedFileDir = getServletContext().getRealPath("") + File.separator + CONVERTED_DIR;
            List<CompletableFuture<Path>> futures
                    = result.saveFiles(Paths.get(convertedFileDir));

            if (futures.isEmpty()) {
                throw new IOException("La conversion n'a produit aucun fichier.");
            }

            List<Path> savedFiles = new ArrayList<>();
            for (CompletableFuture<Path> future : futures) {
                savedFiles.add(future.get());
            }

            String convertedFileName = savedFiles.get(0).getFileName().toString();
            String fileUrl = request.getContextPath() + "/download?file=" + convertedFileName;
            String viewUrl = request.getContextPath() + "/download?file=" + convertedFileName + "&action=view";

            String fullFileUrl = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + fileUrl;
            String whatsappUrl = "https://wa.me/?text=Voici le fichier converti: " + fullFileUrl;
            String telegramUrl = "https://t.me/share/url?url=" + fullFileUrl + "&text=Voici le fichier converti";

            request.setAttribute("fileUrl", fileUrl);
            request.setAttribute("viewUrl", viewUrl);
            request.setAttribute("whatsappUrl", whatsappUrl);
            request.setAttribute("telegramUrl", telegramUrl);
            request.setAttribute("fileName", convertedFileName);

        } catch (InterruptedException | ExecutionException e) {
            e.printStackTrace(response.getWriter());
            request.setAttribute("error", "Erreur lors de la conversion: " + e.getMessage());
        } finally {
            uploadedFile.delete();
        }

        request.getRequestDispatcher("accueil.jsp").forward(request, response);
    }
}
