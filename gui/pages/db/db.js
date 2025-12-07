const dbContainer = document.getElementById('db-container');
const btnVoltar = document.getElementById('back-btn');

btnVoltar?.addEventListener('click', () => {
  window.history.back();
})

const databases = [
  { 
    name: 'Postgres', 
    description: 'Banco relacional PostgreSQL',
    fields: [
      { label: 'Usuário', type: 'text', default: 'admin', id: 'user' },
      { label: 'Senha', type: 'password', default: 'admin', id: 'password' },
      { label: 'Porta', type: 'number', default: 5432, id: 'port' },
      { label: 'Database', type: 'text', default: 'appdb', id: 'database' }
    ]
  },
  { 
    name: 'MySQL', 
    description: 'Banco relacional MySQL',
    fields: [
      { label: 'Usuário', type: 'text', default: 'admin', id: 'user' },
      { label: 'Senha', type: 'password', default: 'admin', id: 'password' },
      { label: 'Porta', type: 'number', default: 3306, id: 'port' },
      { label: 'Database', type: 'text', default: 'appdb', id: 'database' }
    ]
  },
  { 
    name: 'MariaDB', 
    description: 'Banco relacional compatível com MySQL',
    fields: [
      { label: 'Usuário', type: 'text', default: 'admin', id: 'user' },
      { label: 'Senha', type: 'password', default: 'admin', id: 'password' },
      { label: 'Porta', type: 'number', default: 3307, id: 'port' },
      { label: 'Database', type: 'text', default: 'appdb', id: 'database' }
    ]
  },
  { 
    name: 'MongoDB', 
    description: 'Banco de documentos NoSQL',
    fields: [
      { label: 'Usuário', type: 'text', default: 'admin', id: 'user' },
      { label: 'Senha', type: 'password', default: 'admin', id: 'password' },
      { label: 'Porta', type: 'number', default: 27017, id: 'port' },
      { label: 'Database', type: 'text', default: 'appdb', id: 'database' }
    ]
  },
  { 
    name: 'Redis', 
    description: 'Cache e banco em memória',
    fields: [
      { label: 'Porta', type: 'number', default: 6379, id: 'port' }
    ]
  },
  { 
    name: 'SQLite', 
    description: 'Banco de dados leve e local',
    fields: [
      { label: 'Arquivo DB', type: 'text', default: 'app.sqlite', id: 'file' }
    ]
  },
  { 
    name: 'Cassandra', 
    description: 'Banco NoSQL distribuído',
    fields: [
      { label: 'Usuário', type: 'text', default: 'cassandra', id: 'user' },
      { label: 'Senha', type: 'password', default: 'cassandra', id: 'password' },
      { label: 'Porta', type: 'number', default: 9042, id: 'port' },
      { label: 'Keyspace', type: 'text', default: 'appkeyspace', id: 'keyspace' }
    ]
  },
  { 
    name: 'CouchDB', 
    description: 'Banco NoSQL orientado a documentos',
    fields: [
      { label: 'Usuário', type: 'text', default: 'admin', id: 'user' },
      { label: 'Senha', type: 'password', default: 'admin', id: 'password' },
      { label: 'Porta', type: 'number', default: 5984, id: 'port' },
      { label: 'Database', type: 'text', default: 'appdb', id: 'database' }
    ]
  }
];

databases.forEach(db => {
  const col = document.createElement('div');
  col.classList.add('col-md-4', 'mb-4');

  const card = document.createElement('div');
  card.classList.add('card', 'h-100');

  const cardBody = document.createElement('div');
  cardBody.classList.add('card-body', 'd-flex', 'flex-column');

  const title = document.createElement('h5');
  title.classList.add('card-title');
  title.textContent = db.name;

  const desc = document.createElement('p');
  desc.classList.add('card-text');
  desc.textContent = db.description;

  const checkboxDiv = document.createElement('div');
  checkboxDiv.classList.add('form-check', 'mb-2');

  const checkbox = document.createElement('input');
  checkbox.type = 'checkbox';
  checkbox.id = db.name;
  checkbox.classList.add('form-check-input');

  const label = document.createElement('label');
  label.setAttribute('for', db.name);
  label.classList.add('form-check-label');
  label.textContent = 'Selecionar';

  checkboxDiv.appendChild(checkbox);
  checkboxDiv.appendChild(label);

  cardBody.appendChild(title);
  cardBody.appendChild(desc);
  cardBody.appendChild(checkboxDiv);

  db.fields.forEach(field => {
    const fieldDiv = document.createElement('div');
    fieldDiv.classList.add('mb-2');

    const fieldLabel = document.createElement('label');
    fieldLabel.setAttribute('for', `${db.name}-${field.id}`);
    fieldLabel.classList.add('form-label');
    fieldLabel.textContent = field.label;

    const input = document.createElement('input');
    input.type = field.type;
    input.id = `${db.name}-${field.id}`;
    input.classList.add('form-control');
    if(field.default !== undefined) input.value = field.default;

    fieldDiv.appendChild(fieldLabel);
    fieldDiv.appendChild(input);
    cardBody.appendChild(fieldDiv);
  });

  card.appendChild(cardBody);
  col.appendChild(card);
  dbContainer.appendChild(col);
});

document.getElementById('next-btn').addEventListener('click', () => {
  const selected = databases.filter(db => document.getElementById(db.name).checked)
                            .map(db => {
                              const obj = { name: db.name };
                              db.fields.forEach(field => {
                                obj[field.id] = document.getElementById(`${db.name}-${field.id}`).value;
                              });
                              return obj;
                            });
  console.log(selected);
  alert(`Selecionados: ${selected.map(d => d.name).join(', ')}`);
});
