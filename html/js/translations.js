// js/translations.js
function applyTranslations(translations) {
    // Aplicar traducciones a elementos con data-i18n
    document.querySelectorAll('[data-i18n]').forEach(element => {
        const key = element.getAttribute('data-i18n');
        if (translations[key]) {
            element.textContent = translations[key];
        }
    });

    // Aplicar traducciones a placeholders con data-i18n-placeholder
    document.querySelectorAll('[data-i18n-placeholder]').forEach(element => {
        const key = element.getAttribute('data-i18n-placeholder');
        if (translations[key]) {
            element.placeholder = translations[key];
        }
    });
}

function loadTranslations() {
    fetch('../translation/translation.json') // Ruta relativa desde html/js/
        .then(response => {
            if (!response.ok) {
                throw new Error('No se pudo cargar translation.json');
            }
            return response.json();
        })
        .then(data => {
            // Por defecto, usar español si no se especifica idioma
            let language = 'es';
            
            // Opcional: Detectar idioma desde un evento de FiveM o una variable global
            if (window.selectedLanguage) {
                language = window.selectedLanguage;
            }

            const translations = data[language] || data['es']; // Fallback a español si el idioma no existe
            applyTranslations(translations);
        })
        .catch(error => {
            console.error('Error cargando traducciones:', error);
        });
}

// Escuchar eventos de FiveM para cambiar idioma (opcional)
window.addEventListener('message', function(event) {
    if (event.data.type === 'setLanguage') {
        fetch('../translation/translation.json')
            .then(response => response.json())
            .then(data => {
                const translations = data[event.data.language] || data['es'];
                applyTranslations(translations);
            })
            .catch(error => console.error('Error cambiando idioma:', error));
    }
});

// Cargar traducciones cuando el DOM esté listo
document.addEventListener('DOMContentLoaded', loadTranslations);