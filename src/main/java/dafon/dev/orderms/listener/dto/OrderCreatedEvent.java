package dafon.dev.orderms.listener.dto;

import java.util.List;

public record OrderCreatedEvent(Long codeOrder, Long codeClient, List<OrderItemEvent> itens ) {

}
