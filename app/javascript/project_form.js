// 用 Turbo 事件，避免只在第一次載入觸發
document.addEventListener("turbo:load", function () {
  const projectTypeSelect = document.getElementById("project_type_select");
  if (!projectTypeSelect) return;

  const sections = Array.from(document.querySelectorAll(".project-type-fields"));

  function toggleFields() {
    const selected = projectTypeSelect.value;

    sections.forEach((section) => {
      const types = (section.dataset.projectTypes || "")
        .split(",")
        .map((type) => type.trim())
        .filter(Boolean);

      if (types.includes(selected)) {
        section.classList.remove("d-none");
      } else {
        section.classList.add("d-none");
      }
    });
  }

  toggleFields();
  projectTypeSelect.addEventListener("change", toggleFields);
});
