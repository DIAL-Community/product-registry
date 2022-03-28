# frozen_string_literal: true

json.array! @contacts, partial: 'contacts/contact', as: :contact
