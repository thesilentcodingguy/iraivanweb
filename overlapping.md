

# 🔹 jQuery Version

### ✅ HTML

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Image Hover Zoom</title>
  <link rel="stylesheet" href="style.css">
</head>
<body>

<div class="overlay"></div>

<div class="container">
  <img src="https://picsum.photos/id/1015/400/300" class="img img1">
  <img src="https://picsum.photos/id/1016/300/400" class="img img2">
  <img src="https://picsum.photos/id/1018/350/350" class="img img3">
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="script-jq.js"></script>

</body>
</html>
```

---

### 🎨 CSS (`style.css`)

```css
body {
  margin: 0;
  background: #f5f5f5;
  font-family: sans-serif;
}

.container {
  position: relative;
  width: 600px;
  margin: 100px auto;
}

.img {
  position: absolute;
  border-radius: 10px;
  cursor: pointer;
  transition: all 0.4s ease;
}

/* Different sizes & positions */
.img1 {
  width: 260px;
  top: 0;
  left: 50px;
  z-index: 1;
}

.img2 {
  width: 220px;
  top: 80px;
  left: 200px;
  z-index: 2;
}

.img3 {
  width: 240px;
  top: 160px;
  left: 100px;
  z-index: 3;
}

/* Overlay */
.overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0,0,0,0.6);
  opacity: 0;
  visibility: hidden;
  transition: 0.3s;
}

/* Active states */
.overlay.active {
  opacity: 1;
  visibility: visible;
}

.img.active {
  position: fixed;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%) scale(1.4);
  z-index: 10;
}
```

---

### ⚙️ jQuery (`script-jq.js`)

```javascript
$(document).ready(function () {

  $(".img").hover(
    function () {
      $(".overlay").addClass("active");
      $(this).addClass("active");
    },
    function () {
      $(".overlay").removeClass("active");
      $(this).removeClass("active");
    }
  );

});
```

---

# 🔹 Vanilla JavaScript Version

### ⚙️ JS (`script.js`)

```javascript
const images = document.querySelectorAll(".img");
const overlay = document.querySelector(".overlay");

images.forEach(img => {
  img.addEventListener("mouseenter", () => {
    overlay.classList.add("active");
    img.classList.add("active");
  });

  img.addEventListener("mouseleave", () => {
    overlay.classList.remove("active");
    img.classList.remove("active");
  });
});
```


Just tweak the **active image scale** 👇

### 🔧 Change in CSS

```css
.img.active {
  position: fixed;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%) scale(2); /* increased from 1.4 → 2 */
  z-index: 10;
}
```

👉 Increase `scale(2)` to `scale(2.5)` or `3` if you want it even bigger.
