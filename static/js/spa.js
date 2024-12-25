// const SPA = {
//     currentTab: 'voting',

//     init() {
//         this.showContent('voting');

//         document.querySelectorAll('.nav a').forEach(tab => {
//             tab.addEventListener('click', (e) => {
//                 e.preventDefault();
//                 const tabName = tab.getAttribute('data-tab');
//                 this.showContent(tabName);
//                 this.updateActiveTab(tabName);
//             });
//         });

//         this.updateActiveTab('voting');
//     },

//     async showContent(tab) {
//         const mainContent = document.getElementById('spa-content');
//         this.currentTab = tab;

//         switch (tab) {
//             case 'voting':
//                 const votingContent = await this.fetchContent('/cat1');
//                 mainContent.innerHTML = votingContent;
//                 this.attachVotingEventListeners();
//                 break;

//             case 'breeds':
//                 const breedsContent = await this.fetchContent('/cat/breeds');
//                 mainContent.innerHTML = breedsContent;
//                 this.initializeSelect2();
//                 break;

//             case 'favs':
//                 const favsContent = await this.fetchContent('/cat/favs');
//                 mainContent.innerHTML = favsContent;
//                 break;
//         }
//     },

//     async fetchContent(url) {
//         try {
//             const response = await fetch(url);
//             const html = await response.text();
//             const tempDiv = document.createElement('div');
//             tempDiv.innerHTML = html;
//             const container = tempDiv.querySelector('.container') || tempDiv;
//             return container.innerHTML;
//         } catch (error) {
//             console.error('Error fetching content:', error);
//             return '<div class="error">Failed to load content</div>';
//         }
//     },

//     updateActiveTab(tabName) {
//         document.querySelectorAll('.nav a').forEach(tab => {
//             if (tab.getAttribute('data-tab') === tabName) {
//                 tab.classList.add('active');
//                 tab.style.backgroundColor = '#e0e0e0';
//             } else {
//                 tab.classList.remove('active');
//                 tab.style.backgroundColor = 'transparent';
//             }
//         });
//     },

//     // Function to extract image ID from URL
//     getImageIdFromUrl(url) {
//         const parts = url.split('/');
//         const filename = parts[parts.length - 1];
//         return filename.split('.')[0];
//     },

//     async attachVotingEventListeners() {
//         // Handle love button clicks
//         const loveButton = document.getElementById('love-button');
//         if (loveButton) {
//             loveButton.addEventListener('click', async () => {
//                 try {
//                     loveButton.disabled = true;
//                     const imageUrl = document.getElementById('catImage').src;
//                     const imageId = this.getImageIdFromUrl(imageUrl);

//                     const response = await fetch('/cat/love', {
//                         method: 'POST',
//                         headers: {
//                             'Content-Type': 'application/json',
//                         },
//                         body: JSON.stringify({
//                             image_id: imageId,
//                             sub_id: "user-123",
//                         })
//                     });

//                     const result = await response.json();

//                     if (response.ok) {
//                         alert('Successfully added to favorites!');
//                         loveButton.style.backgroundColor = '#ffecec';
//                         // Refresh the content after successful love
//                         await this.showContent('voting');
//                     } else {
//                         throw new Error(result.error || 'Failed to add to favorites');
//                     }
//                 } catch (error) {
//                     console.error('Error:', error);
//                     alert('Error: ' + error.message);
//                 } finally {
//                     loveButton.disabled = false;
//                 }
//             });
//         }

//         // Handle voting submissions
//         document.querySelectorAll('form[action="/cat/vote"]').forEach(form => {
//             form.onsubmit = async (e) => {
//                 e.preventDefault();
//                 try {
//                     const formData = new FormData(form);
//                     const data = {
//                         image_id: formData.get('image_id'),
//                         vote: formData.get('vote'),
//                         sub_id: "user-123", // You may use a user identifier if needed
//                     };

//                     const response = await fetch('/cat/vote', {
//                         method: 'POST',
//                         headers: {
//                             'Content-Type': 'application/json',
//                         },
//                         body: JSON.stringify(data)
//                     });

//                     if (response.ok) {
//                         await this.showContent('voting');
//                     } else {
//                         const result = await response.json();
//                         throw new Error(result.error || 'Failed to submit vote');
//                     }
//                 } catch (error) {
//                     console.error('Error:', error);
//                     alert('Error: ' + error.message);
//                 }
//             };
//         });
//     }
//     ,

//     initializeSelect2() {
//         if (typeof $ !== 'undefined') {
//             $('#breed').select2();
//             $('#breed').on('change', async (e) => {
//                 const breedId = e.target.value;
//                 if (breedId) {
//                     const content = await this.fetchContent(`/cat/breed_images?id=${breedId}`);
//                     document.getElementById('spa-content').innerHTML = content;
//                     this.initializeSlideshow();
//                 }
//             });
//         }
//     },

//     initializeSlideshow() {
//         let slideIndex = 0;
//         const slides = document.getElementsByClassName("slide");

//         if (!slides.length) return;

//         function showSlides(n) {
//             if (n >= slides.length) slideIndex = 0;
//             if (n < 0) slideIndex = slides.length - 1;

//             for (let i = 0; i < slides.length; i++) {
//                 slides[i].style.display = "none";
//             }
//             slides[slideIndex].style.display = "block";
//         }

//         function changeSlide(n) {
//             showSlides(slideIndex += n);
//         }

//         const prevButton = document.querySelector('.prev');
//         const nextButton = document.querySelector('.next');
//         if (prevButton) prevButton.onclick = () => changeSlide(-1);
//         if (nextButton) nextButton.onclick = () => changeSlide(1);

//         showSlides(slideIndex);
//         setInterval(() => changeSlide(1), 5000);
//     }
// };

// document.addEventListener('DOMContentLoaded', () => {
//     SPA.init();
// });
