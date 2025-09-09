FactoryBot.define do
  factory :status_usuario do
    sequence(:Id) { |n| n }
    Status { 'Ativo' }
  end

  factory :tipo_acesso do
    sequence(:Id) { |n| n }
    Tipo { 'Admin' }
  end

  factory :tipo_usuario do
    sequence(:Id) { |n| n }
    Tipo { 'Cliente' }
  end

  factory :tipo_area_cobertura do
    sequence(:Id) { |n| n }
    Tipo { 'Coberto' }
  end

  factory :tipo_barraca do
    sequence(:Id) { |n| n }
    Tipo { 'Normal' }
  end

  factory :status_pedido do
    # Use find_or_create to avoid duplicates for default
    to_create { |instance| StatusPedido.find_or_create_by(Id: 1) { |sp| sp.Status = 'Pendente' } }
    Id { 1 }
    Status { 'Pendente' }

    trait :completed do
      # Use find_or_create to avoid duplicates
      to_create { |instance| StatusPedido.find_or_create_by(Id: 4) { |sp| sp.Status = 'Finalizado' } }
      Id { 4 }
      Status { 'Finalizado' }
    end
  end

  factory :status_pedido_item do
    # Use find_or_create to avoid duplicates for default (using ID 2 to avoid conflicts)
    to_create { |instance| StatusPedidoItem.find_or_create_by(Id: 2) { |spi| spi.Status = 'Confirmado' } }
    Id { 2 }
    Status { 'Confirmado' }

    trait :confirmed do
      # Use find_or_create to avoid duplicates
      to_create { |instance| StatusPedidoItem.find_or_create_by(Id: 1) { |spi| spi.Status = 'Confirmado' } }
      Id { 1 }
      Status { 'Confirmado' }
    end

    trait :cancelled do
      # Use find_or_create to avoid duplicates
      to_create { |instance| StatusPedidoItem.find_or_create_by(Id: 3) { |spi| spi.Status = 'Cancelado' } }
      Id { 3 }
      Status { 'Cancelado' }
    end
  end

  factory :tipo_produto do
    sequence(:Id) { |n| n }
    Tipo { 'Bebida' }
  end

  factory :status_item do
    sequence(:Id) { |n| n }
    Status { 'Ativo' }
  end

  factory :tipo_entrega do
    sequence(:Id) { |n| n }
    Tipo { 'Mesa' }
  end
end