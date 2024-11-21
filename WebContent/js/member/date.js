let startDate = new Date('2024-01-01'); //가입 날짜 
let endDate = new Date('2024-12-31'); //현재 날짜
let diffTime = endDate.getTime() - startDate.getTime();
let diffDays = diffTime / (1000 * 60 * 60 * 24);
console.log(diffDays); // 두 날짜 간의 차이가 일 단위로 출력