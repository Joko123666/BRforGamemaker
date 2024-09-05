draw_set_font(Font01);
switch (game_state)
{
	case "title" :
		title_draw();
		
	break;
	
	case "stage_select" :
		stage_select_draw();
		 draw_text(room_width / 2 - 100, room_height / 2, "좌우 키로 스테이지 선택");
	    draw_stage_info(); // 스테이지 정보 그리기

		draw_black_transition(); // 검은색 화면 전환 그리기
	break;
	
	case "playing" :
		if (!global.is_paused) {
	    // 일시정지 상태가 아닐 때는 게임을 정상적으로 그리기
		for (var i = 1; i <= road_number ; i++)
		{
			switch (i)
			{
				case 1 : road_image_index = 2;
				break;
				case 2 : road_image_index = 0;
				break;
				case 3 : road_image_index = 0;
				break;
				case 4 : road_image_index = 1;
				break;
			}
			road_draw(i, road_image_index);
		}
		} else {
		    // 일시정지 상태일 때는 일시정지 메뉴 그리기
		    draw_pause_menu();
		}
	break;
	
	
}
