import Input from "./Input";

class PasswordInput extends Input {
  constructor(id, label, defaultValue = '') {
    super(id, label, defaultValue);
  }

  render() {
    const div = document.createElement('div');
    div.classList.add('mb-2');

    const labelEl = document.createElement('label');
    labelEl.setAttribute('for', this.id);
    labelEl.classList.add('form-label');
    labelEl.textContent = this.label;

    const inputGroup = document.createElement('div');
    inputGroup.classList.add('input-group');

    const input = document.createElement('input');
    input.type = 'password';
    input.id = this.id;
    input.classList.add('form-control');
    input.value = this.defaultValue;

    const toggleBtn = document.createElement('button');
    toggleBtn.type = 'button';
    toggleBtn.classList.add('btn', 'btn-outline-secondary');
    toggleBtn.textContent = '👁';

    toggleBtn.addEventListener('click', () => {
      if(input.type === 'password') {
        input.type = 'text';
        toggleBtn.textContent = '🙈';
      } else {
        input.type = 'password';
        toggleBtn.textContent = '👁';
      }
    });

    inputGroup.appendChild(input);
    inputGroup.appendChild(toggleBtn);

    div.appendChild(labelEl);
    div.appendChild(inputGroup);

    return div;
  }
}

export default PasswordInput;