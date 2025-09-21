// Get all category buttons and skill categories
const categoryButtons = document.querySelectorAll(".category-btn");
const skillCategories = document.querySelectorAll(".skill-category");

const experienceButtons = document.querySelectorAll(".experience-button");
const experienceCategories = document.querySelectorAll(".experience-category");

const projectButtons = document.querySelectorAll(".project-button");
const projectCategories = document.querySelectorAll(".project-category");

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

    experienceButtons.forEach((btn) => btn.classList.remove("active"));
    experienceCategories.forEach((category) =>
      category.classList.remove("active")
    );

    button.classList.add("active");
    document.getElementById(categoryName).classList.add("active");
  });
});

projectButtons.forEach((button) => {
  button.addEventListener("click", () => {
    const categoryName = button.dataset.category;

    projectButtons.forEach((btn) => btn.classList.remove("active"));
    projectCategories.forEach((category) =>
      category.classList.remove("active")
    );

    button.classList.add("active");
    document.getElementById(categoryName).classList.add("active");
  });
});
