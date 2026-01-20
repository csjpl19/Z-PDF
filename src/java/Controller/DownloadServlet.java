package Controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/download")
public class DownloadServlet extends HttpServlet {

    private static final String CONVERTED_DIR = "converted_files";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String fileName = request.getParameter("file");
        if (fileName == null || fileName.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Nom du fichier introuvable.");
            return;
        }

        String convertedFileDir = getServletContext().getRealPath("") + File.separator + CONVERTED_DIR;
        File file = new File(convertedFileDir, fileName);

        if (!file.exists()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Fichier introuvable.");
            return;
        }

        response.setContentType(getServletContext().getMimeType(fileName));
        response.setContentLength((int) file.length());
        
        //visualiser ou telecharger
        String action = request.getParameter("action");
        if ("view".equals(action)) {
            response.setHeader("Content-Disposition", "inline; filename=\"" + file.getName() + "\"");
        } else {
            response.setHeader("Content-Disposition", "attachment; filename=\"" + file.getName() + "\"");
        }

        try (FileInputStream in = new FileInputStream(file);
             OutputStream out = response.getOutputStream()) {

            byte[] buffer = new byte[4096];
            int bytesRead;
            while ((bytesRead = in.read(buffer)) != -1) {
                out.write(buffer, 0, bytesRead);
            }
        }
    }
}
