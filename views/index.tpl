<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cat Gallery</title>
    
    <!-- Include jQuery and Select2 -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.13/css/select2.min.css" rel="stylesheet" />
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.13/js/select2.min.js"></script>
    <script src="/static/js/spa.js"></script>
</head>
<body style="font-family: Arial, sans-serif; background-color: #f9f9f9; margin: 0; padding: 0;">
    <!-- Tab Navigation -->
    <div class="nav" style="display: flex; justify-content: space-around; margin-bottom: 20px;">
        <a data-tab="voting" class="voting active" style="text-decoration: none; color: #333; font-weight: bold; font-size: 16px; padding: 10px 20px; transition: color 0.3s, background-color 0.3s; border-radius: 5px; cursor: pointer;">
            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="stroke: #666; fill: none; stroke-width: 2;">
                <path d="M12 20V4M4 12l8-8 8 8"/>
            </svg>
            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="stroke: #666; fill: none; stroke-width: 2;">
                <path d="M12 4v16M4 12l8 8 8-8"/>
            </svg>
            Voting
        </a>
        <a data-tab="breeds" class="breeds" style="text-decoration: none; color: #333; font-weight: bold; font-size: 16px; padding: 10px 20px; transition: color 0.3s, background-color 0.3s; border-radius: 5px; cursor: pointer;">
            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="stroke: #666; fill: none; stroke-width: 2;">
                <circle cx="11" cy="11" r="8"/>
                <path d="M21 21l-4.35-4.35"/>
            </svg>
            Breeds
        </a>
        <a data-tab="favs" class="favs" style="text-decoration: none; color: #333; font-weight: bold; font-size: 16px; padding: 10px 20px; transition: color 0.3s, background-color 0.3s; border-radius: 5px; cursor: pointer;">
            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="stroke: #ff6b6b; fill: none; stroke-width: 2;">
                <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78L12 21.23l8.84-8.84a5.5 5.5 0 0 0 0-7.78z"/>
            </svg>
            Favs
        </a>
    </div>
    
    <!-- Main content area -->
    <div id="spa-content" style="display: flex; justify-content: center; align-items: center; min-height: 100vh; padding: 20px;">
        <div class="container" style="display: flex; flex-direction: column; align-items: center; justify-content: center; background-color: #fff; border-radius: 10px; box-shadow: 0 0 10px rgba(0, 0, 0, 0.1); padding: 20px; text-align: center; width: 600px; margin: 50px auto;">
            <img id="catImage" src="{{.ImageURL}}" alt="Cat Image" style="width: 500px; height: 300px; object-fit: cover; display: block; margin: 0 auto 20px; border-radius: 10px;">
            <div class="button-row" style="position: relative; margin-top: 20px; width: 100%; max-width: 300px;">
                <div class="love-button" style="position: absolute; bottom: 0; left: 0; transform: translate(10%, 100%);">
                    <button type="button" id="love-button" title="Love" style="background-color: #f0f0f0; border: none; border-radius: 5px; padding: 10px; cursor: pointer; transition: background-color 0.3s; font-size: 20px; color: #ff6b6b;">❤️</button>
                </div>
                <div class="like-dislike-buttons" style="position: absolute; bottom: 0; right: 0; transform: translate(-10%, 100%);">
                    <form action="/cat/vote" method="POST">
                        <input type="hidden" name="image_id" value="{{.ImageURL}}">
                        <button type="submit" name="vote" value="1" title="Like" style="background-color: #f0f0f0; border: none; border-radius: 5px; padding: 10px; cursor: pointer; transition: background-color 0.3s; font-size: 16px;">👍</button>
                        <button type="submit" name="vote" value="-1" title="Dislike" style="background-color: #f0f0f0; border: none; border-radius: 5px; padding: 10px; cursor: pointer; transition: background-color 0.3s; font-size: 16px;">👎</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Function to extract image ID from URL
        function getImageIdFromUrl(url) {
            const parts = url.split('/');
            const filename = parts[parts.length - 1];
            return filename.split('.')[0];
        }

        document.addEventListener('DOMContentLoaded', function() {
            const loveButton = document.getElementById('love-button');
            const imageUrl = document.getElementById('catImage').src;
            
            loveButton.addEventListener('click', async () => {
                try {
                    loveButton.disabled = true;
                    
                    const imageId = getImageIdFromUrl(imageUrl);
                    const response = await fetch('/cat/love', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json',
                        },
                        body: JSON.stringify({
                            image_id: imageId,
                            sub_id: "user-123",
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
                    loveButton.disabled = false;
                }
            });
        });
    </script>
</body>
</html>