function createPost() {
    var title = document.getElementById("post-title").value;
    var content = document.getElementById("post-content").value;
  
    if (title && content) {
      var postContainer = document.getElementById("post-container");
  
      var newPost = document.createElement("div");
      newPost.className = "post";
  
      var postTitle = document.createElement("h2");
      postTitle.className = "post-title";
      postTitle.innerHTML = title;
  
      var postDate = document.createElement("p");
      postDate.className = "post-date";
      postDate.innerHTML = "Posted on " + getCurrentDate();
  
      var postContent = document.createElement("p");
      postContent.className = "post-content";
      postContent.innerHTML = content;
  
      newPost.appendChild(postTitle);
      newPost.appendChild(postDate);
      newPost.appendChild(postContent);
  
      postContainer.insertBefore(newPost, postContainer.firstChild);
  
      // Clear input fields
      document.getElementById("post-title").value = "";
      document.getElementById("post-content").value = "";
    } else {
      alert("Please enter a title and content for the post.");
    }
  }
  
  function getCurrentDate() {
    var date = new Date();
    var month = date.toLocaleString("default", { month: "long" });
    var day = date.getDate();
    var year = date.getFullYear();
    return month + " " + day + ", " + year;
  }
  