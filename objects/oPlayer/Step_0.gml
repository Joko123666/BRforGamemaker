// 메인 스텝 이벤트에서 실행
player_move();
if (keyboard_check_pressed(vk_space)) {
    destroy_object();
}
if (keyboard_check_pressed(vk_shift)) {
    player_use_special();
}
// oPlayer의 Step 이벤트에서 주행 거리 업데이트
global.stage_distance += oPlayer.now_speed / room_speed;  // 주행 거리를 초당 속도로 증가