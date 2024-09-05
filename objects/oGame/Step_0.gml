

switch (game_state)
{
	case "title" :
		title_input();
	break;
	
	case "stage_select" :
		stage_select_input();
		draw_text(room_width / 2 - 100, room_height / 2, "좌우 키로 스테이지 선택");
	    draw_stage_info(); // 선택한 스테이지 정보 그리기
		//update_transition();
	    //stage_select_input(); // 애니메이션 중엔 입력을 받지 않음
		if (!global.is_paused) {
	    if (!is_transitioning) {
	        game_stage_input(); // 게임 진행 중 입력 처리
	    }
	    update_black_transition(); // 화면 전환 애니메이션 업데이트
		} else {
		    pause_menu_input(); // 일시정지 메뉴 입력 처리
		}

		update_input(); // 입력 상태 업데이트
	break;
	
	case "playing" :
		//player_move();
	road_scroll(); // 스테이지 진행 중 도로 스크롤 처리
	
	if (!global.is_paused) {
    // 일시정지 상태가 아니면 일반적인 게임 입력 처리
    game_stage_input();
	} else {
	    // 일시정지 상태일 때는 일시정지 메뉴 입력 처리
	    pause_menu_input();
	}

	update_input(); // 입력 상태 업데이트
	break;
	
	
}
