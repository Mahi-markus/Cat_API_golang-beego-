<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cat Gallery</title>
</head>
<body>
    <!-- Tab Navigation -->
    <div class="nav" style="display: flex; justify-content: space-around; margin-bottom: 20px;">
        <a data-tab="voting" class="voting active" style="text-decoration: none; color: #333; font-weight: bold; font-size: 16px; padding: 10px 20px; transition: color 0.3s, background-color 0.3s; border-radius: 5px; cursor: pointer;">
            Voting
        </a>
        <a data-tab="breeds" class="breeds" style="text-decoration: none; color: #333; font-weight: bold; font-size: 16px; padding: 10px 20px; transition: color 0.3s, background-color 0.3s; border-radius: 5px; cursor: pointer;">
            Breeds
        </a>
        <a data-tab="favs" class="favs" style="text-decoration: none; color: #333; font-weight: bold; font-size: 16px; padding: 10px 20px; transition: color 0.3s, background-color 0.3s; border-radius: 5px; cursor: pointer;">
            Favs
        </a>
    </div>
    
    <!-- Main content area -->
    <div id="spa-content" style="display: flex; justify-content: center; align-items: center; height: 100vh; padding: 20px;">
        <div class="container" style="display: flex; flex-direction: column; align-items: center; justify-content: center; background-color: #fff; border-radius: 10px; box-shadow: 0 0 10px rgba(0, 0, 0, 0.1); padding: 20px; text-align: center;">
            <img id="catImage" src="{{.ImageURL}}" alt="Cat Image" style="max-width: 100%; max-height: 300px; border-radius: 10px; object-fit: cover; margin-bottom: 20px;">
            <div class="button-row" style="display: flex; justify-content: space-between; width: 100%; max-width: 300px;">
                <div class="love-button">
                    <button type="button" id="love-button" title="Love" style="background-color: #f0f0f0; border: none; border-radius: 5px; padding: 10px; cursor: pointer; transition: background-color 0.3s; font-size: 20px; color: #ff6b6b;">❤️</button>
                </div>
                <div class="like-dislike-buttons">
                    <form action="/cat/vote" method="POST">
                        <input type="hidden" name="image_url" value="{{.ImageURL}}">
                        <button type="submit" name="vote" value="up" title="Like" style="background-color: #f0f0f0; border: none; border-radius: 5px; padding: 10px; cursor: pointer; transition: background-color 0.3s; font-size: 16px;">👍</button>
                        <button type="submit" name="vote" value="down" title="Dislike" style="background-color: #f0f0f0; border: none; border-radius: 5px; padding: 10px; cursor: pointer; transition: background-color 0.3s; font-size: 16px;">👎</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Function to extract image ID from URL
        function getImageIdFromUrl(url) {
            // Example URL: https://cdn2.thecatapi.com/images/MTk3ODc5MA.jpg
            const parts = url.split('/');
            const filename = parts[parts.length - 1];
            return filename.split('.')[0]; // Remove file extension
        }

        document.addEventListener('DOMContentLoaded', function() {
            const loveButton = document.getElementById('love-button');
            const imageUrl = document.getElementById('catImage').src;
            
            loveButton.addEventListener('click', async () => {
                try {
                    // Disable button to prevent double clicks
                    loveButton.disabled = true;
                    
                    const imageId = getImageIdFromUrl(imageUrl);
                    const response = await fetch('/cat/love', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json',
                        },
                        body: JSON.stringify({
                            image_id: imageId,
                            sub_id: "user-123", // You can make this dynamic if needed
                            image_url: imageUrl
                        })
                    });

                    const result = await response.json();
                    
                    if (response.ok) {
                        alert('Successfully added to favorites!');
                        loveButton.style.backgroundColor = '#ffecec';
                    } else {
                        throw new Error(result.error || 'Failed to add to favorites');
                    }
                } catch (error) {
                    console.error('Error:', error);
                    alert('Error: ' + error.message);
                } finally {
                    // Re-enable button
                    loveButton.disabled = false;
                }
            });
        });
    </script>
</body>
</html>