// 1. Lógica de la barra de navegación
function inicializarNavbar() {



	const btnAbrir = document.getElementById("btn-abrir-menu");
	const btnCerrar = document.getElementById("btn-cerrar-menu");
	const menuPrincipal = document.getElementById("menu-principal");

	if (!btnAbrir || !btnCerrar || !menuPrincipal) return;

	const abrirMenu = () => {
		menuPrincipal.classList.add("barra_navegacion__menu--activo");
		btnAbrir.classList.add("oculto");
		btnCerrar.classList.remove("oculto");
		btnAbrir.setAttribute("aria-expanded", "true");
		document.body.style.overflow = "hidden";
	};

	const cerrarMenu = () => {
		menuPrincipal.classList.remove("barra_navegacion__menu--activo");
		btnCerrar.classList.add("oculto");
		btnAbrir.classList.remove("oculto");
		btnAbrir.setAttribute("aria-expanded", "false");
		document.body.style.overflow = "";
	};


	btnAbrir.onclick = abrirMenu;
	btnCerrar.onclick = cerrarMenu;


	menuPrincipal.querySelectorAll("a").forEach((enlace) => {
		enlace.addEventListener("click", () => {
			if (window.innerWidth < 992) {
				cerrarMenu();
			}
		});
	});
}

// 2. Lógica del Tema Oscuro/Claro
function inicializarTema() {
	const themeToggleButton = document.getElementById("theme-toggle");
	const themeIcon = document.getElementById("theme-icon");

	if (!themeToggleButton || !themeIcon) return;

	const setTheme = (theme) => {
		if (theme === "dark") {
			document.documentElement.setAttribute("data-theme", "dark");
			themeIcon.textContent = "";
			localStorage.setItem("theme", "dark");
		} else {
			document.documentElement.removeAttribute("data-theme");
			themeIcon.textContent = "";
			localStorage.setItem("theme", "light");
		}
	};

	const savedTheme = localStorage.getItem("theme");
	const systemPrefersDark = window.matchMedia("(prefers-color-scheme: dark)").matches;

	if (savedTheme) {
		setTheme(savedTheme);
	} else if (systemPrefersDark) {
		setTheme("dark");
	}

	// Alternar el tema al hacer clic
	themeToggleButton.onclick = () => {
		const currentTheme = document.documentElement.getAttribute("data-theme");
		if (currentTheme === "dark") {
			setTheme("light");
		} else {
			setTheme("dark");
		}
	};
}


//3. Logica Copys
function InicizalizarCopys() {
	try {
		const data = {
			"homeSubtitles": [
				"Diseño y desarrollo interfaces web desde cero con un fuerte enfoque frontend.",
				"Desarrollador Full Stack con especialidad en Sistemas de Información, creando soluciones web desde cero con enfoque en Web Performance, automatización y datos.",
				"Experto en el desarrollo con JavaScript, Node.js y PHP, modelando y normalizando bases de datos para asegurar la integridad estructural de la información.",
				"Especializado en la automatización de procesos y optimización de datos, desarrollando middlewares de integración para CRM e interfaces de alto rendimiento.",
				"Con experiencia en la administración de Google Cloud Platform y despliegue automatizado de aplicaciones en producción mediante Cloud Run y Cloud Build.",
				"Construcción de portales web, sistemas internos y herramientas de auditoría técnica con un fuerte enfoque en escalabilidad, SEO y rendimiento superior."
			]
		};

		const subtitles = data.homeSubtitles;
		const subtitleElement = document.getElementById('home-subtitle');

		if (subtitleElement) {
			let currentIndex = 0;

			// Función para cambiar el texto con un efecto visual suave (fade)
			const changeSubtitle = () => {
				// 1. Desvanecer texto actual
				subtitleElement.style.opacity = 0;
				subtitleElement.style.transition = "opacity 0.4s ease-in-out";

				setTimeout(() => {
					// 2. Seleccionar un índice aleatorio (asegurando que no se repita de inmediato si hay más de 2)
					let newIndex;
					do {
						newIndex = Math.floor(Math.random() * subtitles.length);
					} while (newIndex === currentIndex && subtitles.length > 1);

					currentIndex = newIndex;

					// 3. Asignar el nuevo texto
					subtitleElement.textContent = subtitles[currentIndex];

					// 4. Volver a mostrar el texto
					subtitleElement.style.opacity = 1;
				}, 400); // Tiempo que coincide con la transición CSS
			};

			// Ejecutar el cambio cada 4 segundos (4000 milisegundos) en tiempo real
			setInterval(changeSubtitle, 6000);
		}

	} catch (error) {
		console.error("Error al cargar los copys dinámicos:", error);
		const subtitleElement = document.getElementById('home-subtitle');
		if (subtitleElement) {
			subtitleElement.textContent = "Más de 4 años de experiencia transformando requerimientos complejos en arquitecturas modernas con JavaScript (Node.js, React) y despliegues optimizados en Google Cloud Platform.";
		}
	}
}


document.addEventListener("astro:page-load", () => {
	inicializarNavbar();
	inicializarTema();
	InicizalizarCopys()
});





