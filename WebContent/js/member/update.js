document.getElementById('updateForm').addEventListener('submit', function(event) {
    // 입력 필드 값 가져오기
    const name = document.getElementById('name').value.trim();
    const nickname = document.getElementById('nickname').value.trim();
    const phone = document.getElementById('phone').value.trim();
    const address = document.getElementById('address').value.trim();
    
    
    // 이름 유효성 검사: 2자 이상, 10자 이하
    if (name.length < 2 || name.length > 10) {
        alert('이름은 2자 이상, 10자 이하로 입력해주세요.');
        event.preventDefault();
        return;
    }

    // 닉네임 유효성 검사: 2자 이상, 10자 이하
    if (nickname.length < 2 || nickname.length > 10) {
        alert('닉네임은 2자 이상, 10자 이하로 입력해주세요.');
        event.preventDefault();
        return;
    }

    // 전화번호 유효성 검사: 숫자만 입력되었는지 확인
    const phoneRegex = /^\d{10,11}$/; // 10~11자리 숫자만 허용
    if (!phoneRegex.test(phone)) {
        alert('전화번호는 10~11자리 숫자로 입력해주세요.');
        event.preventDefault();
        return;
    }

    // 주소 유효성 검사: 빈 값 확인
    if (address === '') {
        alert('주소를 입력해주세요.');
        event.preventDefault();
        return;
    }

    // 모든 유효성 검사를 통과하면 폼이 제출됩니다.
    alert('유효성 검사를 통과했습니다. 제출합니다.');
});