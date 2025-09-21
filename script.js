// Get all category buttons and skill categories
const categoryButtons = document.querySelectorAll(".category-btn");
const skillCategories = document.querySelectorAll(".skill-category");

const experienceButtons = document.querySelectorAll(".experience-button");
const experienceCategories = document.querySelectorAll(".experience-category");

// Add click event listeners to category buttons
categoryButtons.forEach((button) => {
  button.addEventListener("click", () => {
    const categoryName = button.dataset.category;

    // Remove active class from all buttons and categories
    categoryButtons.forEach((btn) => btn.classList.remove("active"));
    skillCategories.forEach((category) => category.classList.remove("active"));

    // Add active class to clicked button and corresponding category
    button.classList.add("active");
    document.getElementById(categoryName).classList.add("active");
  });
});

experienceButtons.forEach((button) => {
  button.addEventListener("click", () => {
    const categoryName = button.dataset.category;

    // Remove active class from all buttons and categories
    experienceButtons.forEach((btn) => btn.classList.remove("active"));
    experienceCategories.forEach((category) =>
      category.classList.remove("active")
    );

    // Add active class to clicked button and corresponding category
    button.classList.add("active");
    document.getElementById(categoryName).classList.add("active");
  });
});
