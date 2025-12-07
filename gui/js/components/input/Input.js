class Input {
  constructor(id, label, defaultValue = '') {
    if (this.constructor === Input) {
      throw new Error("Classe 'Input' é abstrata e não pode ser instanciada diretamente.");
    }
    this.id = id;
    this.label = label;
    this.defaultValue = defaultValue;
  }

  render() {
    throw new Error("Método 'render()' deve ser implementado nas subclasses.");
  }
}

export default Input;