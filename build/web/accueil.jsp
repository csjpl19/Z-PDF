<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
    <head>
        <title>Z-pdf - Conversion</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="Style/style.css"/>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    </head>
    <body>
        <header>
            <div class="container">
                <div class="header-content">
                    <div class="logo">
                        <h1>Z-<span>PDF</span></h1>
                    </div>
                    <nav>
                        <ul>
                            <li><a href="index.html">Home</a></li>
                            <li><a href="#">About us</a></li>
                            <li><a href="#">Contacts</a></li>
                        </ul>
                    </nav>
                </div>
            </div>
        </header>

        <section class="converter-section">
            <div class="container">
                <div class="converter-container">
                    <h1>Convertisseur de <span>Documents</span></h1>

                    <form class="converter-form" action="convert" method="post" enctype="multipart/form-data" id="converterForm">
                        <div class="form-group">
                            <label for="fromFormat">De :</label>
                            <select id="fromFormat" name="fromFormat">
                                <option value="pdf">PDF</option>
                                <option value="docx">Word (DOCX)</option>
                                <option value="xlsx">Excel (XLSX)</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="toFormat">À :</label>
                            <select id="toFormat" name="toFormat">
                                <option value="docx">Word (DOCX)</option>
                                <option value="pdf">PDF</option>
                                <option value="xlsx">Excel (XLSX)</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="file">Choisissez votre fichier :</label>
                            <input type="file" id="file" name="file" required accept=".pdf,.docx,.xlsx">

                            <div class="error-message" id="formatError">
                                <i class="fas fa-exclamation-circle"></i> 
                                <span id="errorText">Le format du fichier ne correspond pas au format sélectionné. Veuillez choisir un fichier de type <span id="expectedFormat"></span>.</span>
                            </div>
                        </div>

                        <button type="submit" class="btn-convert" id="convertButton">
                            <span id="buttonText">Convertir</span>
                            <div class="spinner" id="spinner" style="display: none;">
                                <div class="spinner-dot"></div>
                                <div class="spinner-dot"></div>
                                <div class="spinner-dot"></div>
                            </div>
                        </button>
                        <div class="error-message" id="networkError" style="display:none;">
                            <i class="fas fa-wifi"></i>
                            <span>Connexion Internet requise. Veuillez vous connecter pour continuer.</span>
                        </div>

                    </form>

                    <div class="result-section" id="resultSection" style="${not empty fileUrl or not empty error ? 'display:block;' : 'display:none;'}">
                        <c:if test="${not empty fileUrl}">
                            <div class="result-success">
                                <div class="success-icon">
                                    <i class="fas fa-check-circle"></i>
                                </div>
                                <h2>Conversion Réussie !</h2>
                                <p>Votre document a été converti avec succès.</p>

                                <div class="file-info">
                                    <i class="fas fa-file"></i>
                                    <div>
                                        <h3>${fileName}</h3>
                                        <p>Document converti</p>
                                    </div>
                                </div>

                                <div class="action-buttons">
                                    <a href="${fileUrl}" class="action-btn download-btn" download="${fileName}">
                                        <i class="fas fa-download"></i>
                                        <span>Télécharger</span>
                                    </a>
                                    <a href="${viewUrl}" class="action-btn view-btn" target="_blank">
                                        <i class="fas fa-eye"></i>
                                        <span>Visualiser</span>
                                    </a>
                                </div>

                                <div class="share-section">
                                    <h4>Partager ce document</h4>
                                    <div class="share-buttons">
                                        <a href="${whatsappUrl}" target="_blank" class="share-btn whatsapp">
                                            <i class="fab fa-whatsapp"></i>
                                            WhatsApp
                                        </a>
                                        <a href="${telegramUrl}" target="_blank" class="share-btn telegram">
                                            <i class="fab fa-telegram"></i>
                                            Telegram
                                        </a>
                                        <button class="share-btn copy-link" onclick="copyToClipboard('${fullFileUrl}')">
                                            <i class="fas fa-copy"></i>
                                            Copier le lien
                                        </button>
                                    </div>
                                </div>

                                <button class="new-conversion-btn" onclick="resetForm()">
                                    <i class="fas fa-sync-alt"></i>
                                    Nouvelle conversion
                                </button>
                            </div>
                        </c:if>
                        <c:if test="${not empty error}">
                            <div class="result-error">
                                <div class="error-icon">
                                    <i class="fas fa-exclamation-triangle"></i>
                                </div>
                                <h2>Erreur de Conversion</h2>
                                <p>${error}</p>
                                <button class="retry-btn" onclick="resetForm()">
                                    <i class="fas fa-redo"></i>
                                    Réessayer
                                </button>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
        </section>

        <footer>
            <div class="container">
                <div class="footer-content">
                    <div class="footer-info">
                        <div class="footer-logo">
                            <h3>Z-<span>PDF</span></h3>
                        </div>
                        <p>Convertissez vos documents de manière plus fiable et en les partageant plus rapidement.</p>
                    </div>
                    <div class="footer-links">
                        <div class="footer-column">
                            <h4>Navigation</h4>
                            <ul>
                                <li><a href="index.html">Home</a></li>
                                <li><a href="#">How it works</a></li>
                                <li><a href="#">About us</a></li>
                            </ul>
                        </div>
                        <div class="footer-column">
                            <h4>Support</h4>
                            <ul>
                                <li><a href="#">Contacts</a></li>
                                <li><a href="#">FAQ</a></li>
                                <li><a href="#">Politique de confidentialité</a></li>
                            </ul>
                        </div>
                    </div>
                </div>
                <div class="copyright">
                    <p>&copy; 2026 Z-PDF. Tous droits réservés.</p>
                </div>
            </div>
        </footer>

        <script>
            document.addEventListener('DOMContentLoaded', function () {
                const fileInput = document.getElementById('file');
                const fromFormat = document.getElementById('fromFormat');
                const formatError = document.getElementById('formatError');
                const errorText = document.getElementById('errorText');
                const expectedFormat = document.getElementById('expectedFormat');
                const converterForm = document.getElementById('converterForm');
                const convertButton = document.getElementById('convertButton');
                const buttonText = document.getElementById('buttonText');
                const spinner = document.getElementById('spinner');
                const resultSection = document.getElementById('resultSection');

                fileInput.addEventListener('change', function () {
                    const file = this.files[0];
                    if (file) {
                        const fileName = file.name.toLowerCase();
                        const selectedFormat = fromFormat.value.toLowerCase();

                        const formatExtensions = {
                            'pdf': '.pdf',
                            'docx': '.docx',
                            'xlsx': '.xlsx'
                        };

                        const expectedExtension = formatExtensions[selectedFormat];
                        const fileExtension = fileName.substring(fileName.lastIndexOf('.'));

                        if (expectedExtension && fileExtension !== expectedExtension) {
                            expectedFormat.textContent = selectedFormat.toUpperCase();
                            formatError.style.display = 'block';
                            convertButton.disabled = true;
                        } else {
                            formatError.style.display = 'none';
                            convertButton.disabled = false;
                        }
                    }
                });
                fromFormat.addEventListener('change', function () {
                    if (fileInput.files.length > 0) {
                        // Déclencher la vérification à nouveau
                        fileInput.dispatchEvent(new Event('change'));
                    }
                });
                converterForm.addEventListener('submit', function (e) {
                    if (!convertButton.disabled) {
                        showLoading();
                    }
                });
                const networkError = document.getElementById('networkError');

                function updateNetworkStatus() {
                    if (!navigator.onLine) {
                        convertButton.disabled = true;
                        networkError.style.display = 'block';
                    } else {
                        networkError.style.display = 'none';
                        if (formatError.style.display === 'none') {
                            convertButton.disabled = false;
                        }
                    }
                }

                updateNetworkStatus();
                window.addEventListener('offline', updateNetworkStatus);
                window.addEventListener('online', updateNetworkStatus);

            });

            function showLoading() {
                const buttonText = document.getElementById('buttonText');
                const spinner = document.getElementById('spinner');
                const convertButton = document.getElementById('convertButton');

                buttonText.style.opacity = 'none';
                spinner.style.display = 'flex';
                convertButton.disabled = true;
            }

            function hideLoading() {
                const buttonText = document.getElementById('buttonText');
                const spinner = document.getElementById('spinner');
                const convertButton = document.getElementById('convertButton');

                buttonText.style.opacity = '1';
                spinner.style.display = 'none';
                convertButton.disabled = false;
            }

            function resetForm() {
                const form = document.getElementById('converterForm');
                const resultSection = document.getElementById('resultSection');

                form.reset();
                resultSection.style.display = 'none';
                hideLoading();
            }

            function copyToClipboard(text) {
                navigator.clipboard.writeText(text).then(function () {
                    const copyBtn = document.querySelector('.copy-link');
                    const originalText = copyBtn.innerHTML;

                    copyBtn.innerHTML = '<i class="fas fa-check"></i> Lien copié !';
                    copyBtn.classList.add('copied');

                    setTimeout(() => {
                        copyBtn.innerHTML = originalText;
                        copyBtn.classList.remove('copied');
                    }, 2000);
                }).catch(function (err) {
                    console.error('Erreur lors de la copie : ', err);
                });
            }
        </script>
    </body>
</html>