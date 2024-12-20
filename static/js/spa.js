// spa.js
const SPA = {
    currentTab: 'voting',  // Changed default tab to voting

    init() {
        // Load initial voting content
        this.showContent('voting');  // Changed to load voting by default
        
        // Handle tab clicks
        document.querySelectorAll('.nav a').forEach(tab => {
            tab.addEventListener('click', (e) => {
                e.preventDefault();
                const tabName = tab.getAttribute('data-tab');
                this.showContent(tabName);
                this.updateActiveTab(tabName);
            });
        });

        // Set voting tab as active initially
        this.updateActiveTab('voting');
    },

    async showContent(tab) {
        const mainContent = document.getElementById('spa-content');
        this.currentTab = tab;

        switch (tab) {
            case 'voting':
                const votingContent = await this.fetchContent('/cat1');
                mainContent.innerHTML = votingContent;
                this.attachHomeEventListeners();
                break;

            case 'breeds':
                const breedsContent = await this.fetchContent('/cat/breeds');
                mainContent.innerHTML = breedsContent;
                this.initializeSelect2();
                break;

            case 'favs':
                const favsContent = await this.fetchContent('/cat/favs');
                mainContent.innerHTML = favsContent;
                break;
        }
    },

    async fetchContent(url) {
        try {
            const response = await fetch(url);
            const html = await response.text();
            // Extract only the content we need from the response
            const tempDiv = document.createElement('div');
            tempDiv.innerHTML = html;
            const container = tempDiv.querySelector('.container') || tempDiv;
            return container.innerHTML;
        } catch (error) {
            console.error('Error fetching content:', error);
            return '<div class="error">Failed to load content</div>';
        }
    },

    updateActiveTab(tabName) {
        document.querySelectorAll('.nav a').forEach(tab => {
            if (tab.getAttribute('data-tab') === tabName) {
                tab.classList.add('active');
            } else {
                tab.classList.remove('active');
            }
        });
    },

    attachHomeEventListeners() {
        // Handle love button submissions
        document.querySelectorAll('form[action="/cat/love"]').forEach(form => {
            form.onsubmit = async (e) => {
                e.preventDefault();
                const formData = new FormData(form);
                await fetch('/cat/love', {
                    method: 'POST',
                    body: formData
                });
                this.showContent('voting');
            };
        });

        // Handle voting submissions
        document.querySelectorAll('form[action="/cat/vote"]').forEach(form => {
            form.onsubmit = async (e) => {
                e.preventDefault();
                const formData = new FormData(form);
                await fetch('/cat/vote', {
                    method: 'POST',
                    body: formData
                });
                this.showContent('voting');
            };
        });
    },

    initializeSelect2() {
        if (typeof $ !== 'undefined') {
            $('#breed').select2();
            $('#breed').on('change', async (e) => {
                const breedId = e.target.value;
                if (breedId) {
                    const content = await this.fetchContent(`/cat/breed_images?id=${breedId}`);
                    document.getElementById('spa-content').innerHTML = content;
                    this.initializeSlideshow();
                }
            });
        }
    },

    initializeSlideshow() {
        let slideIndex = 0;
        const slides = document.getElementsByClassName("slide");
        
        if (!slides.length) return;

        function showSlides(n) {
            if (n >= slides.length) slideIndex = 0;
            if (n < 0) slideIndex = slides.length - 1;
            
            for (let i = 0; i < slides.length; i++) {
                slides[i].style.display = "none";
            }
            slides[slideIndex].style.display = "block";
        }

        function changeSlide(n) {
            showSlides(slideIndex += n);
        }

        // Attach click handlers to prev/next buttons
        const prevButton = document.querySelector('.prev');
        const nextButton = document.querySelector('.next');
        if (prevButton) prevButton.onclick = () => changeSlide(-1);
        if (nextButton) nextButton.onclick = () => changeSlide(1);

        // Initialize first slide
        showSlides(slideIndex);

        // Auto slide functionality
        setInterval(() => changeSlide(1), 5000);
    }
};

// Initialize SPA when DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
    SPA.init();
});