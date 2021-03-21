function quotify(text) {
    return text.split(/\n/).map(line => '> ' + line).join('\n');
}

document.body.addEventListener('keydown', (event) => {
    if (!(event.ctrlKey && event.key == 'Enter')) {
        return;
    }

    const selected = window.getSelection().toString();
    if (!selected) {
        return;
    }

    const mdFilePath = document.getElementById('md-file-path').value;
    const githubUrl = new URL('https://github.com/GoldsteinE/blog/issues/new');
    githubUrl.search = new URLSearchParams({
        title: 'Ошибка в ' + mdFilePath,
        body: quotify(selected),
    });

    const modal = document.createElement('aside');
    modal.classList.add('modal');
    modal.append(
        'Нашли ошибку? Создать issue на GitHub?'
    );

    const buttonsContainer = document.createElement('div');
    buttonsContainer.classList.add('modal-buttons-container');

    const noButton = document.createElement('a');
    noButton.classList.add('modal-button');
    noButton.href = '#';
    noButton.addEventListener('click', (event) => {
        event.preventDefault();
        modal.remove();
    });
    noButton.append('Нет');

    const yesButton = document.createElement('a');
    yesButton.classList.add('modal-button');
    yesButton.href = githubUrl;
    yesButton.target = '_blank';
    yesButton.addEventListener('click', () => {
        modal.remove();
    });
    yesButton.append('Да');

    buttonsContainer.appendChild(noButton);
    buttonsContainer.appendChild(yesButton);
    modal.appendChild(buttonsContainer);

    document.body.appendChild(modal);
})
